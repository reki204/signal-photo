// ページが読み込まれたときの処理
window.onload = async () => {
  // JSON ファイルを非同期で読み込む
  const encryptedData = await fetch('encrypted.json').then(res => res.json());
  // 復号化
  const decrypted = await aesDecrypt(encryptedData, encrypt_password, salt);

  // データURLを生成して表示
  const dataURL = "data:image/png;base64," + decrypted;
  const img = document.createElement('img');
  img.src = dataURL;
  document.body.appendChild(img);
};

// AES 復号化関数
async function aesDecrypt(data, encrypt_password, salt) {
  const { subtle } = crypto;
  const key = await subtle.importKey(
    'raw',
    new TextEncoder().encode(encrypt_password),
    'PBKDF2',
    false,
    ['deriveKey']
  );

  const derivedKey = await subtle.deriveKey(
    {
      name: 'PBKDF2',
      salt: new TextEncoder().encode(salt),
      iterations: 100000,
      hash: 'SHA-256'
    },
    key,
    {
      name: 'AES-CBC',
      length: 256
    },
    false,
    ['encrypt', 'decrypt']
  );

  const iv = atob(data.iv);
  const ivArrayBuffer = new Uint8Array(iv.length);
  for (let i = 0; i < iv.length; i++) {
    ivArrayBuffer[i] = iv.charCodeAt(i);
  }

  const encrypted = atob(data.encrypted);
  const encryptedArrayBuffer = new Uint8Array(encrypted.length);
  for (let i = 0; i < encrypted.length; i++) {
    encryptedArrayBuffer[i] = encrypted.charCodeAt(i);
  }

  const decryptedArrayBuffer = await subtle.decrypt(
    {
      name: 'AES-CBC',
      iv: ivArrayBuffer
    },
    derivedKey,
    encryptedArrayBuffer
  );

  return new TextDecoder().decode(decryptedArrayBuffer);
}
