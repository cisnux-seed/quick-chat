import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/data/models/user_model.dart';
import 'package:quick_chat/domain/usecases/get_users.dart';

part 'search_account_state.dart';

class SearchAccountCubit extends Cubit<SearchAccountState> {
  SearchAccountCubit(this.getUsers) : super(SearchAccountInitial());

  final GetUsers getUsers;
  StreamSubscription<List<UserModel>>? _searchListener;

  void fetchUsers(String keyword, UserModel currentUser) {
    final result = getUsers.execute(keyword, currentUser);

    result.fold(
      (failure) => emit(SearchAccountError(failure.message)),
      (success) => _searchListener = success.listen(
        (users) => emit(SearchAccountSuccess(users)),
      ),
    );
  }

  @override
  Future<void> close() async {
    if (_searchListener != null) {
      await _searchListener?.cancel();
    }
    return super.close();
  }

  void setStateToEmpty() => emit(SearchAccountInitial());
}
