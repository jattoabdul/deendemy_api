# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password, :password_confirmation,

  # Card capture
  :card_cvv, :cvv, :token_id, :tokenId, :token_data, :tokenData,

  # Magtek/Magensa card capture
  :track1, :track2, :track3, :magneprint, :magneprintStatus, :magneprint_status,
  :device_sn, :deviceSN, :key_sn, :keySN,
  :emv_sred_data, :emvSredData, :encryption_type, :encryptionType, :padded_bytes, :paddedBytes
]
