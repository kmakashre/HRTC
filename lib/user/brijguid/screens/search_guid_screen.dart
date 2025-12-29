import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/brijguid/models/temple_model.dart';
import 'package:hrtc/user/brijguid/provider/brajdarshan_provider.dart';
import 'package:hrtc/user/brijguid/screens/guid_booking.dart';
import 'package:hrtc/user/brijguid/widgets/tour_card.dart';

class SearchGuideScreen extends ConsumerStatefulWidget {
  const SearchGuideScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchGuideScreen> createState() => _SearchGuideScreenState();
}

class _SearchGuideScreenState extends ConsumerState<SearchGuideScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brajDarshanProvider);
    final filteredGuides = _filterGuides(state.tourGuides);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.servicesGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Search Tour Guides',
          style: AppSizes.headingMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(
            child:
                filteredGuides.isEmpty
                    ? _buildNoResults()
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMedium,
                        vertical: AppSizes.paddingSmall,
                      ),
                      itemCount: filteredGuides.length,
                      itemBuilder: (context, index) {
                        final guide = filteredGuides[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: AppSizes.paddingMedium,
                          ),
                          child: TourGuideCard(
                            guide: guide,
                            isSelected: state.selectedGuideId == guide.id,
                            onTap: () {
                              ref
                                  .read(brajDarshanProvider.notifier)
                                  .selectGuide(guide.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          GuideBookingScreen(guide: guide),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: AppSizes.paddingMedium),
          _buildFilterOptions(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search guides by name, language, specialization...',
          hintStyle: AppSizes.bodyMedium.copyWith(color: Colors.grey.shade500),
          prefixIcon: Container(
            padding: EdgeInsets.all(AppSizes.paddingSmall),
            child: const Icon(
              Icons.search,
              color: AppColors.servicesAccent,
              size: 20,
            ),
          ),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingMedium,
          ),
        ),
        style: AppSizes.bodyMedium.copyWith(color: AppColors.textPrimary),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by:',
          style: AppSizes.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSizes.paddingSmall),
        SizedBox(
          height: 35,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('All'),
              _buildFilterChip('Available'),
              _buildFilterChip('High Rating'),
              _buildFilterChip('English Speaking'),
              _buildFilterChip('Experienced'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: EdgeInsets.only(right: AppSizes.paddingSmall),
      child: FilterChip(
        label: Text(
          filter,
          style: AppSizes.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.servicesAccent,
        backgroundColor: Colors.grey.shade100,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.servicesAccent : Colors.grey.shade300,
            width: 1,
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSmall,
          vertical: 2,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? filter : 'All';
          });
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingLarge),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_pin,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'No tour guides found',
            style: AppSizes.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Try adjusting your search or filters',
            style: AppSizes.bodySmall.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  List<TourGuide> _filterGuides(List<TourGuide> guides) {
    return guides.where((guide) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          guide.name.toLowerCase().contains(_searchQuery) ||
          guide.description.toLowerCase().contains(_searchQuery) ||
          guide.languages.any(
            (lang) => lang.toLowerCase().contains(_searchQuery),
          ) ||
          guide.specializations.any(
            (spec) => spec.toLowerCase().contains(_searchQuery),
          );
      if (!matchesSearch) return false;

      switch (_selectedFilter) {
        case 'All':
          return true;
        case 'Available':
          return guide.isAvailable;
        case 'High Rating':
          return guide.rating >= 4.8;
        case 'English Speaking':
          return guide.languages.contains('English');
        case 'Experienced':
          return guide.experience.contains('15+') ||
              guide.experience.contains('12+');
        default:
          return true;
      }
    }).toList();
  }
}
