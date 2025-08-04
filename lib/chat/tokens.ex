defmodule Chat.Tokens do
  @secret_key Application.compile_env!(:chat, __MODULE__)[:encryption_key]

  @aad ""
  @tag_length 16
  @iv_length 12

  def encrypt(data) when is_map(data) do
    json = Jason.encode!(data)
    iv = :crypto.strong_rand_bytes(@iv_length)
    key = :crypto.hash(:sha256, @secret_key)
    {ciphertext, tag} = :crypto.crypto_one_time_aead(:aes_256_gcm, key, iv, json, @aad, @tag_length, true)
    (iv <> tag <> ciphertext)
    |> Base.encode64()
  end

  def decrypt(token) do
    with {:ok, bin} <- Base.decode64(token),
         <<iv::binary-size(@iv_length), tag::binary-size(@tag_length), ciphertext::binary>> <- bin,
         key = :crypto.hash(:sha256, @secret_key),
         {:ok, plaintext} <- decrypt_aead(ciphertext, key, iv, tag),
         {:ok, data} <- Jason.decode(plaintext) do
      {:ok, data}
    else
      error ->
        IO.inspect(error, label: "Decrypt error")
        {:error, "corrupted token"}
    end
  end

  defp decrypt_aead(ciphertext, key, iv, tag) do
    try do
      plaintext = :crypto.crypto_one_time_aead(:aes_256_gcm, key, iv, ciphertext, @aad, tag, false)
      {:ok, plaintext}
    rescue
      _ -> {:error, :invalid}
    end
  end
end
