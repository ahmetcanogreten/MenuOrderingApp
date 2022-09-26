import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthenticationRepository {
  Future<User?> signUp({required String email, required String password});

  Future<User?> signIn({required String email, required String password});

  Future<String> getUserRole({required String userId});
}

class AuthenticationRepository extends IAuthenticationRepository {
  @override
  Future<User?> signUp(
      {required String email, required String password}) async {
    final res = await Supabase.instance.client.auth.signUp(email, password);

    return res.user;
  }

  @override
  Future<User?> signIn(
      {required String email, required String password}) async {
    final res = await Supabase.instance.client.auth.signIn(
      email: email,
      password: password,
    );

    return res.user;
  }

  @override
  Future<String> getUserRole({required String userId}) async {
    final res = await Supabase.instance.client
        .from('role')
        .select()
        .eq('userId', userId)
        .execute();

    if (res.hasError) {
      return 'user';
    } else {
      return ((res.data! as List).first as Map<String, dynamic>)['role'];
    }
  }
}
