class Headroom < Formula
  desc "Admission control for parallel coding agents on one Mac"
  homepage "https://github.com/cybagard/cyba-headroom"
  url "https://github.com/cybagard/cyba-headroom/releases/download/v0.2.1/headroom-v0.2.1-darwin-arm64.tar.gz"
  sha256 "f2b5a83d74e608e2f22ff12715ffa456336f8faf03220ac85eddcfb1facc3cfa"
  license "AGPL-3.0-only"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "headroom"
  end

  def caveats
    <<~EOS
      Always give brew the full name, cybagard/tap/headroom: to install, reinstall,
      upgrade, info and uninstall. The short name, headroom, resolves to an
      unrelated cask (Headroom.app); that includes brew's own hint
      `brew reinstall headroom`. Only `brew services` takes the short name.

      Start the daemon now and at login (it also links the shims):
        brew services start headroom
      Set each Orca agent's command to:
        headroom run -- <agent>
      Do not also run `headroom install`.

      Optional, for login shells (zsh -l, bash -l, a terminal or SSH): /etc/zprofile
      runs path_helper, which moves the shim directory behind /usr/local/bin. For
      zsh, add these lines at the end of both ~/.zlogin and ~/.zshrc:
        # headroom: shims first (also in login shells, after path_helper)
        typeset -U path
        path=("$HOME/.config/headroom/shims" $path)
      For bash, add this line at the end of the first of ~/.bash_profile,
      ~/.bash_login and ~/.profile that exists (create ~/.bash_profile only if none does):
        export PATH="$HOME/.config/headroom/shims:$PATH"
      See https://github.com/cybagard/cyba-headroom#login-shells

      Before you uninstall, stop the service:
        brew services stop headroom
        brew uninstall cybagard/tap/headroom
      Then remove the shim links:
        rm -rf ~/.config/headroom/shims
      That keeps the config, the samples, the lock file d.sock.lock and the logs.
      To remove all of them, and then the shell lines above if you added them:
        rm -rf ~/.config/headroom ~/Library/Logs/headroom

      The service does not see DOCKER_HOST, HEADROOM_CONFIG_DIR or OLLAMA_HOST
      from your shell.
    EOS
  end

  service do
    run [opt_bin/"headroom", "daemon", "--log", "~/Library/Logs/headroom/daemon.log", "--link-shims", "--wait"]
    keep_alive true
  end

  test do
    assert_match "headroom v#{version}", shell_output("#{bin}/headroom version")
  end
end
