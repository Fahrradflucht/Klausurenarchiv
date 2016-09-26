defmodule Klausurenarchiv.UploadViewTest do
	use Klausurenarchiv.ConnCase, async: true

	import Klausurenarchiv.UploadView

	test "upload_file_url returns the static plug path" do
		Application.put_env(:klausurenarchiv, :store, path: "/tmp")

		assert upload_file_url("/tmp/my/file.txt") == "/data/my/file.txt"
	end

end