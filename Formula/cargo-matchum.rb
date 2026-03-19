class CargoMatchum < Formula
  desc "Cargo subcommand for spell-checking Rust projects"
  homepage "https://github.com/youknowone/matchum"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/cargo-matchum-aarch64-apple-darwin.tar.xz"
      sha256 "d7f88a93da0804abde43a0ef71f827ab3e2f54dfe7b28c37ca4ce4488e9a36b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/cargo-matchum-x86_64-apple-darwin.tar.xz"
      sha256 "e1c09b2a0e4f20665fe79329a30a8cd102a5c5e6c86c5ce42a402e5c37f5e1f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/cargo-matchum-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "457d81cf64bbd435c4e1d1625ec67d31c10a4841382031166d49ad570147eb9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/youknowone/matchum/releases/download/v0.0.1/cargo-matchum-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e983ea69fc0f725de4a05f56f8b447bbb5904e530aa3c5d7ac6fd2ddfd391238"
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
    bin.install "cargo-matchum" if OS.mac? && Hardware::CPU.arm?
    bin.install "cargo-matchum" if OS.mac? && Hardware::CPU.intel?
    bin.install "cargo-matchum" if OS.linux? && Hardware::CPU.arm?
    bin.install "cargo-matchum" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
