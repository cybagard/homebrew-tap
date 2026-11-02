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
      Start the daemon now and at login (it also links the shims):
        brew services start headroom
      Set each Orca agent's command to:
        headroom run -- <agent>
      Do not also run `headroom install`.

      Before you uninstall, stop the service:
        brew services stop headroom
        brew uninstall cybagard/tap/headroom
      Then remove the shim links:
        rm -rf ~/.config/headroom/shims

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
