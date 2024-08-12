import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/models/account.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/providers/auth.dart' as providers_auth;
import 'package:slaap/utils/firestore_doc.dart';

class AccountProvider {
  static final provider = Provider((ref) => AccountService());

  static final currentAccountProvider = StreamProvider((ref) {
    final user =
        ref.watch(providers_auth.AuthProvider.authStateProvider).requireValue!;
    return ref.watch(provider).currentAccount(user);
  });

  static final getAccountProvider =
      FutureProvider.family<Account, String>((ref, id) {
    return ref.watch(provider).getAccount(id);
  });
}

class AccountService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Account?> currentAccount(User user) {
    return firestore
        .collection("accounts")
        .doc(user.uid)
        .snapshots()
        .map(fromFirestore(Account.fromMap));
  }

  Future<Account> getAccount(String id) async {
    final account = await firestore
        .collection("accounts")
        .doc(id)
        .get()
        .then(fromFirestore(Account.fromMap));
    if (account == null) throw Exception("Account not found");
    return account;
  }

  Future<Account> getAccountByEmail(String email) async {
    final account = await firestore
        .collection("accounts")
        .where("email", isEqualTo: email)
        .limit(1)
        .get()
        .then(fromFirestoreQuery(Account.fromMap))
        .then((value) => value.firstOrNull);
    if (account == null) throw Exception("Account not found");
    return account;
  }

  Future<(Account account, bool isNew)> upsert(User user) async {
    // get existing account if exists
    var account = await firestore
        .collection("accounts")
        .doc(user.uid)
        .get()
        .then(fromFirestore(Account.fromMap));
    if (account != null) return (account, false);

    // user email is required
    final email = user.email;
    if (email == null) {
      throw Exception("User account does not have an email address");
    }

    // create a new account
    final newAccount = Account(
      id: "",
      email: email,
      name: user.displayName ?? "Unnamed User",
      lang: Lang.all(SupportedLang.english.value),
      photoURL: user.photoURL,
    );
    await firestore
        .collection("accounts")
        .doc(user.uid)
        .set(toFirestore(newAccount.toMap));
    return (newAccount, true);
  }

  Future<void> updateLanguage({
    required Lang lang,
    required Account currentAccount,
  }) async {
    await firestore.collection("accounts").doc(currentAccount.id).update({
      "lang.send": lang.send,
      "lang.receive": lang.receive,
    });
  }
}
