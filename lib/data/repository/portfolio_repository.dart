import '../models/profile.dart';
import '../models/project.dart';
import '../data_constants.dart';

abstract class PortfolioRepository {
  Future<Profile> getProfile();
  Future<List<Project>> getProjects();
}

class LocalPortfolioRepository implements PortfolioRepository {
  @override
  Future<Profile> getProfile() async {
    // Simulate minor delay for realism if needed, or return instantly
    return DataConstants.profile;
  }

  @override
  Future<List<Project>> getProjects() async {
    return DataConstants.projects;
  }
}
