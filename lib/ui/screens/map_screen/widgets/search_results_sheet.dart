import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';

class SearchResultsSheet extends StatefulWidget {
  final List<Station> allStations;
  final int minBikes;
  final bool showOnlyAvailable;
  final Function(Station) onStationSelected;

  const SearchResultsSheet({
    super.key,
    required this.allStations,
    required this.onStationSelected,
    this.minBikes = 0,
    this.showOnlyAvailable = false,
  });

  @override
  State<SearchResultsSheet> createState() => _SearchResultsSheetState();
}

class _SearchResultsSheetState extends State<SearchResultsSheet> {
  late TextEditingController _searchController;
  late List<Station> _filteredStations;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredStations = widget.allStations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearch(String query) {
    setState(() {
      var results = widget.allStations;
      if (query.isNotEmpty) {
        results = results
            .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      if (widget.minBikes > 0) {
        results = results
            .where((s) => s.bikeAmounts >= widget.minBikes)
            .toList();
      }
      if (widget.showOnlyAvailable) {
        results = results.where((s) => s.bikeAmounts > 0).toList();
      }
      _filteredStations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search stations...',
                    hintStyle: const TextStyle(
                      color: AppColors.gray400,
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _updateSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.gray100,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.gray100,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.gray50,
                  ),
                  style: const TextStyle(color: AppColors.black, fontSize: 15),
                ),
              ),
              Expanded(
                child: _filteredStations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isEmpty
                                  ? Icons.location_city
                                  : Icons.search_off,
                              size: 48,
                              color: const Color(0xFFCBD5E1),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No stations available'
                                  : 'No stations found',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        itemCount: _filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = _filteredStations[index];
                          final availableSlots =
                              station.totalSlots - station.bikeAmounts;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            child: InkWell(
                              onTap: () => widget.onStationSelected(station),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.gray100,
                                    width: 1.2,
                                  ),
                                  color: AppColors.gray50,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.02),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            station.name,
                                            style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                          color: AppColors.gray400,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _buildStatBadge(
                                          '${station.bikeAmounts}',
                                          Icons.pedal_bike,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildStatBadge(
                                          '$availableSlots',
                                          Icons.local_parking,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            count,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
