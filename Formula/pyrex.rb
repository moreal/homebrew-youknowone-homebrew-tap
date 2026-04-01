class Pyrex < Formula
  desc "pyre executable — Python Rewritten"
  homepage "https://github.com/youknowone/pyre"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/youknowone/pyre/releases/download/v0.0.1/pyrex-aarch64-apple-darwin.tar.xz"
      sha256 "a300af3ac6a34589e26b9b22b069b55c2a2bbe911fd15937404a18153d1f7cfc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/youknowone/pyre/releases/download/v0.0.1/pyrex-x86_64-apple-darwin.tar.xz"
      sha256 "2339cf10bc753ed3ce73e793e7b9ad4d05e2de9299187d7815ab324082c53e83"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/youknowone/pyre/releases/download/v0.0.1/pyrex-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f33fcabbef793f531e6379ba249c7e05a8e53bbc90575484ce2a349ec81d8eb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/youknowone/pyre/releases/download/v0.0.1/pyrex-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5cb410b28cae445134e7ff8446713baa0f4da7284eb9f630402426b7d945c2fc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "pyre" if OS.mac? && Hardware::CPU.arm?
    bin.install "pyre" if OS.mac? && Hardware::CPU.intel?
    bin.install "pyre" if OS.linux? && Hardware::CPU.arm?
    bin.install "pyre" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
