cask "mounty" do
  version "1.2.1"
  sha256 "269ba1e5501c8dc9064be2e271848c9ab7b6eacfccf306ba2ef6057798e9cff7"

  url "https://github.com/maptic/mounty/releases/download/#{version}/Mounty-#{version}.dmg"
  name "Mounty"
  desc "Menu-bar app that keeps SMB network shares mounted automatically"
  homepage "https://github.com/maptic/mounty"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  app "Mounty.app"

  uninstall quit: "ch.maptic.Mounty"

  zap trash: [
    "~/Library/Application Support/ch.maptic.Mounty",
    "~/Library/Caches/ch.maptic.Mounty",
    "~/Library/HTTPStorages/ch.maptic.Mounty",
    "~/Library/Preferences/ch.maptic.Mounty.plist",
    "~/Library/Saved Application State/ch.maptic.Mounty.savedState",
  ]
end
