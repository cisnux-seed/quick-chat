part of 'search_account_cubit.dart';

abstract class SearchAccountState extends Equatable {
  const SearchAccountState();

  @override
  List<Object> get props => [];
}

class SearchAccountInitial extends SearchAccountState {}

class SearchAccountLoading extends SearchAccountState {}

class SearchAccountSuccess extends SearchAccountState {
  final List<UserModel> users;

  const SearchAccountSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class SearchAccountError extends SearchAccountState {
  final String message;

  const SearchAccountError(this.message);

  @override
  List<Object> get props => [message];
}
