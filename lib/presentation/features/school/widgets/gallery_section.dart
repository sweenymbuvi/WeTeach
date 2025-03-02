import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/school/provider/school_photos_provider.dart';
import 'package:we_teach/presentation/features/school/provider/view_school_provider.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  _GallerySectionState createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  int? schoolId;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeData();
      _isInitialized = true;
    }
  }

  void _initializeData() {
    // Get the school ID safely outside of build
    final schoolProvider =
        Provider.of<ViewSchoolProvider>(context, listen: false);
    final jobDetails = schoolProvider.jobDetails;
    final int? newSchoolId = jobDetails?['school']?['id'];

    if (newSchoolId != null && newSchoolId != schoolId) {
      schoolId = newSchoolId;
      // Schedule the fetch operation after the current build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Provider.of<SchoolPhotosProvider>(context, listen: false)
              .fetchSchoolPhotos(schoolId!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolPhotosProvider>(
      builder: (context, photoProvider, child) {
        if (photoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (photoProvider.errorMessage != null) {
          return Center(child: Text(photoProvider.errorMessage!));
        } else if (photoProvider.schoolPhotos == null ||
            photoProvider.schoolPhotos!.isEmpty) {
          return const Center(child: Text("No photos available"));
        }

        // Extract image URLs
        final List<String> imageUrls = photoProvider.schoolPhotos!
            .map((photo) => "https://api.mwalimufinder.com${photo['image']}")
            .toList();

        return _buildGalleryGrid(imageUrls);
      },
    );
  }

  Widget _buildGalleryGrid(List<String> images) {
    if (images.isEmpty) {
      return const Center(child: Text("No photos available"));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 images per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2, // Adjust based on image proportions
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported,
                  size: 50, color: Colors.grey);
            },
          ),
        );
      },
    );
  }
}
