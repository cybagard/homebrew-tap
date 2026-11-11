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

      Login shells (Orca's agent-view and loop agents, scripts) put the real
      docker, podman and tart first. To put the shims first, run:
        headroom shell-setup --apply
      `headroom shell-setup` alone shows what it would change; --remove undoes it.
      To add the lines by hand instead, for zsh put these at the end of both
      ~/.zlogin and ~/.zshrc:
        typeset -U path
        path=("$HOME/.config/headroom/shims" "${path[@]}")
      For bash, add this line at the end of the first of ~/.bash_profile,
      ~/.bash_login and ~/.profile that exists (create ~/.bash_profile only if none does):
        export PATH="$HOME/.config/headroom/shims:$PATH"
      See https://github.com/cybagard/cyba-headroom#login-shells

      Before you uninstall, stop the service and remove the shell block, if added:
        brew services stop headroom
        headroom shell-setup --remove
        brew uninstall cybagard/tap/headroom
      Then remove the shim links:
        rm -rf ~/.config/headroom/shims
      That keeps the config, the samples, the lock file d.sock.lock and the logs.
      To remove all of them, and then any shell lines you added by hand:
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
