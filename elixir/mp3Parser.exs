defmodule ID3Parser do
  def parse(file_name) do
    file_name
    |> File.read
    |> handleMp3
    |> IO.puts
  end

  def handleMp3({:ok, mp3}) do
    size = byte_size(mp3) - 128
    <<_ :: binary-size(size), id3_tag :: binary>> = mp3
    << "TAG", title   :: binary-size(30),
              artist  :: binary-size(30),
              album   :: binary-size(30),
              year    :: binary-size(4),
              _rest   :: binary >> = id3_tag

    "#{artist} - #{title} (#{album}, #{year})"
  end

  def handleMp3(_error) do
    "Could not read file"
  end
end

ID3Parser.parse("test.mp3")