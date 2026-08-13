cask "mounty" do
  version "1.2.2"
  sha256 "f8ca3fce406ffb26a0de311a21c75876f4d3613f2a199b91a546bacc0f0c7c47"

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
