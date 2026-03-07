import '../../data/datasources/local_storage_datasource.dart';
import '../../data/datasources/remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_user_by_email_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  LocalStorageDataSource? _localStorageDataSource;
  RemoteDataSource? _remoteDataSource;
  AuthRepository? _authRepository;
  SignUpUseCase? _signUpUseCase;
  LoginUseCase? _loginUseCase;
  IsLoggedInUseCase? _isLoggedInUseCase;
  LogoutUseCase? _logoutUseCase;
  GetCurrentUserUseCase? _getCurrentUserUseCase;
  GetUserByEmailUseCase? _getUserByEmailUseCase;
  UpdatePasswordUseCase? _updatePasswordUseCase;
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      print('Initializing InjectionContainer...');
      // Initialize Data Sources
      _localStorageDataSource = LocalStorageDataSource();
      await _localStorageDataSource!.init();
      print('LocalStorageDataSource initialized');

      _remoteDataSource = RemoteDataSource();
      // await _remoteDataSource!.init(); // Dio doesn't need explicit init usually
      print('RemoteDataSource initialized');

      // Initialize Repositories
      _authRepository = AuthRepositoryImpl(_localStorageDataSource!, _remoteDataSource!);
      print('AuthRepository initialized');

      // Initialize Use Cases
      _signUpUseCase = SignUpUseCase(_authRepository!);
      _loginUseCase = LoginUseCase(_authRepository!);
      _isLoggedInUseCase = IsLoggedInUseCase(_authRepository!);
      _logoutUseCase = LogoutUseCase(_authRepository!);
      _getCurrentUserUseCase = GetCurrentUserUseCase(_authRepository!);
      _getUserByEmailUseCase = GetUserByEmailUseCase(_authRepository!);
      _updatePasswordUseCase = UpdatePasswordUseCase(_authRepository!);
      print('Use cases initialized');
      
      _isInitialized = true;
      print('InjectionContainer initialization complete');
    } catch (e, stackTrace) {
      print('Error initializing InjectionContainer: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Getters for Use Cases with initialization check
  SignUpUseCase get signUpUseCase {
    if (!_isInitialized || _signUpUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _signUpUseCase!;
  }
  
  LoginUseCase get loginUseCase {
    if (!_isInitialized || _loginUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _loginUseCase!;
  }
  
  IsLoggedInUseCase get isLoggedInUseCase {
    if (!_isInitialized || _isLoggedInUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _isLoggedInUseCase!;
  }
  
  LogoutUseCase get logoutUseCase {
    if (!_isInitialized || _logoutUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _logoutUseCase!;
  }
  
  GetCurrentUserUseCase get getCurrentUserUseCase {
    if (!_isInitialized || _getCurrentUserUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _getCurrentUserUseCase!;
  }

  GetUserByEmailUseCase get getUserByEmailUseCase {
    if (!_isInitialized || _getUserByEmailUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _getUserByEmailUseCase!;
  }
  
  UpdatePasswordUseCase get updatePasswordUseCase {
    if (!_isInitialized || _updatePasswordUseCase == null) {
      throw Exception('InjectionContainer not initialized. Call init() first.');
    }
    return _updatePasswordUseCase!;
  }
}
