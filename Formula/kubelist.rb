class Kubelist < Formula
  desc "Secure wrapper around kubectl that restricts execution to safe commands"
  homepage "https://github.com/exafox/homebrew-kubelist"
  url "https://github.com/exafox/homebrew-kubelist/archive/v1.3.tar.gz"
  sha256 "27b24667f275dfc9fc32606cb520dbf232b0a9f8d5db133e30387411e265e95e"
  license "MIT"
  version "1.3"

  depends_on "kubernetes-cli"

  def caveats
    <<~EOS
      kubelist requires kubectl to function. If you already have kubectl installed
      (e.g., via Docker Desktop, OrbStack, or manual installation), you can skip
      installing the kubernetes-cli dependency by using:
        brew install --ignore-dependencies kubelist
    EOS
  end

  def install
    bin.install "kubelist"
    man1.install "man/man1/kubelist.1"
  end

  test do
    # Test that the binary exists and is executable
    assert_predicate bin/"kubelist", :exist?
    assert_predicate bin/"kubelist", :executable?
    
    # Test help flag
    output = shell_output("#{bin}/kubelist --help")
    assert_match "kubelist - A secure wrapper around kubectl", output
    
    # Test version flag
    output = shell_output("#{bin}/kubelist --version")
    assert_match "kubelist version 1.0.0", output
    
    # Test that unsafe commands are blocked
    output = shell_output("#{bin}/kubelist delete pod test 2>&1", 1)
    assert_match "Command 'delete' is not allowed", output
  end
end
