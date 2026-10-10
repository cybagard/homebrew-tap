class Headroom < Formula
  desc "Admission control for parallel coding agents on one Mac"
  homepage "https://github.com/cybagard/cyba-headroom"
  url "https://github.com/cybagard/cyba-headroom/releases/download/v0.1.0/headroom-v0.1.0-darwin-arm64.tar.gz"
  sha256 "1c00d676c3cff6ac2ca0b3e2f53f09541c3e6d542d60854a494809a2181072e9"
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
