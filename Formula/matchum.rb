class Matchum < Formula
  desc "High-performance spell checker compatible with cspell"
  homepage "https://github.com/youknowone/matchum"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/matchum-aarch64-apple-darwin.tar.xz"
      sha256 "eb1fd260a9b95878da663df169a7285599c6707020be2b75d1594b919b6fa7ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/matchum-x86_64-apple-darwin.tar.xz"
      sha256 "2c883a3c7ec95b62f6c4d31a106510afee538caf63259c7e472ad2cc1347ea25"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/matchum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd1c017639a589845f4ec091987c01e36d4289e99e864072dd2c96cd36809dc3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/matchum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7baa707de21ccff8e9f4495f68818fa2c01bb616748e57ad513edf6d464920b1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "matchum" if OS.mac? && Hardware::CPU.arm?
    bin.install "matchum" if OS.mac? && Hardware::CPU.intel?
    bin.install "matchum" if OS.linux? && Hardware::CPU.arm?
    bin.install "matchum" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
