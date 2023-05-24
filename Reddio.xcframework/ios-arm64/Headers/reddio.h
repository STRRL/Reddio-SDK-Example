#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define BIG_INT_SIZE 65

typedef enum Errno {
  Ok,
  InvalidNullPtr,
  InvalidStr,
  InvalidHex,
  InvalidDecStr,
  InvalidMsg,
  InvalidR,
  InvalidS,
  InternelInvalidK,
  Unknown,
} Errno;

typedef const char *BigInt;

typedef struct SignDocument {
  BigInt private_key;
  BigInt msg_hash;
  BigInt seed;
} SignDocument;

typedef char *MutBigInt;

typedef struct SignResult {
  MutBigInt r;
  MutBigInt s;
} SignResult;

typedef struct Signature {
  BigInt public_key;
  BigInt msg_hash;
  BigInt r;
  BigInt s;
} Signature;

typedef struct TransferMsg {
  /**
   * decimal string
   */
  BigInt amount;
  /**
   * decimal string
   */
  BigInt nonce;
  /**
   * decimal string
   */
  BigInt sender_vault_id;
  /**
   * hex string
   */
  BigInt token;
  /**
   * decimal string
   */
  BigInt receiver_vault_id;
  /**
   * hex string
   */
  BigInt receiver_public_key;
  /**
   * decimal string
   */
  BigInt expiration_time_stamp;
  /**
   * hex string, notice that condition could be nullable
   */
  BigInt condition;
} TransferMsg;

typedef struct TransferMsgWithFee {
  /**
   * decimal string
   */
  BigInt amount;
  /**
   * decimal string
   */
  BigInt nonce;
  /**
   * decimal string
   */
  BigInt sender_vault_id;
  /**
   * hex string
   */
  BigInt token;
  /**
   * decimal string
   */
  BigInt receiver_vault_id;
  /**
   * hex string
   */
  BigInt receiver_stark_key;
  /**
   * decimal string
   */
  BigInt expiration_time_stamp;
  /**
   * hex string
   */
  BigInt fee_token;
  /**
   * decimal string
   */
  BigInt fee_vault_id;
  /**
   * decimal string
   */
  BigInt fee_limit;
  /**
   * hex string, notice that condition could be nullable
   */
  BigInt condition;
} TransferMsgWithFee;

typedef struct LimitOrderMsg {
  /**
   * decimal string
   */
  BigInt vault_sell;
  /**
   * decimal string
   */
  BigInt vault_buy;
  /**
   * decimal string
   */
  BigInt amount_sell;
  /**
   * decimal string
   */
  BigInt amount_buy;
  /**
   * hex string
   */
  BigInt token_sell;
  /**
   * hex string
   */
  BigInt token_buy;
  /**
   * decimal string
   */
  BigInt nonce;
  /**
   * decimal string
   */
  BigInt expiration_time_stamp;
} LimitOrderMsg;

typedef struct LimitOrderMsgWithFee {
  /**
   * decimal string
   */
  BigInt vault_sell;
  /**
   * decimal string
   */
  BigInt vault_buy;
  /**
   * decimal string
   */
  BigInt amount_sell;
  /**
   * decimal string
   */
  BigInt amount_buy;
  /**
   * hex string
   */
  BigInt token_sell;
  /**
   * hex string
   */
  BigInt token_buy;
  /**
   * decimal string
   */
  BigInt nonce;
  /**
   * decimal string
   */
  BigInt expiration_time_stamp;
  /**
   * hex string
   */
  BigInt fee_token;
  /**
   * decimal string
   */
  BigInt fee_vault_id;
  /**
   * decimal string
   */
  BigInt fee_limit;
} LimitOrderMsgWithFee;

typedef struct CancelOrderMsg {
  /**
   * decimal string
   */
  BigInt order_id;
} CancelOrderMsg;

enum Errno sign(struct SignDocument document, struct SignResult ret);

enum Errno verify(struct Signature signature, bool *valid);

enum Errno get_public_key(BigInt private_key, MutBigInt public_key);

const char *explain(enum Errno errno);

enum Errno get_private_key_from_eth_signature(const char *eth_signature, char *private_key_str);

enum Errno get_random_private_key(MutBigInt private_key);

/**
 * Serializes the transfer message in the canonical format expected by the verifier.
 * ref: https://github.com/starkware-libs/starkware-crypto-utils/blob/d3a1e655105afd66ebc07f88a179a3042407cc7b/src/js/signature.js#L352-L418
 */
enum Errno get_transfer_msg_hash(struct TransferMsg msg,
                                 MutBigInt hash);

/**
 * Same as getTransferMsgHash, but also requires the fee info.
 *  ref: https://github.com/starkware-libs/starkware-crypto-utils/blob/d3a1e655105afd66ebc07f88a179a3042407cc7b/src/js/signature.js#L420-L491
 */
enum Errno get_transfer_msg_hash_with_fee(struct TransferMsgWithFee msg,
                                          MutBigInt hash);

/**
 * Serializes the order message in the canonical format expected by the verifier.
 * ref: https://github.com/starkware-libs/starkware-crypto-utils/blob/d3a1e655105afd66ebc07f88a179a3042407cc7b/src/js/signature.js#L226-L283
 */
enum Errno get_limit_order_msg_hash(struct LimitOrderMsg msg,
                                    MutBigInt hash);

/**
 * Same as getLimitOrderMsgHash, but also requires the fee info.
 * ref: https://github.com/starkware-libs/starkware-crypto-utils/blob/d3a1e655105afd66ebc07f88a179a3042407cc7b/src/js/signature.js#L285-L350
 */
enum Errno get_limit_order_msg_hash_with_fee(struct LimitOrderMsgWithFee msg,
                                             MutBigInt hash);

enum Errno get_cancel_order_msg_hash(struct CancelOrderMsg msg, MutBigInt hash);
