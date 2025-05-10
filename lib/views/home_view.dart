import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/file_converter_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FileConverterController());
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
              Colors.purple.shade50,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : 24.0,
              vertical: isSmallScreen ? 12.0 : 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isSmallScreen),
                SizedBox(height: isSmallScreen ? 24.0 : 32.0),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Image Conversions', isSmallScreen),
                        SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                        _buildConversionList(
                          [
                            _buildConversionCard(
                              icon: Icons.image,
                              title: 'PNG to JPG',
                              subtitle: 'Convert PNG images to JPG format',
                              gradient: [
                                Colors.blue.shade500,
                                Colors.blue.shade700
                              ],
                              onTap: () =>
                                  controller.convertImageFormat('png', 'jpg'),
                            ),
                            _buildConversionCard(
                              icon: Icons.image,
                              title: 'JPG to PNG',
                              subtitle: 'Convert JPG images to PNG format',
                              gradient: [
                                Colors.purple.shade500,
                                Colors.purple.shade700
                              ],
                              onTap: () =>
                                  controller.convertImageFormat('jpg', 'png'),
                            ),
                            _buildConversionCard(
                              icon: Icons.image,
                              title: 'BMP to PNG',
                              subtitle: 'Convert BMP images to PNG format',
                              gradient: [
                                Colors.teal.shade500,
                                Colors.teal.shade700
                              ],
                              onTap: () =>
                                  controller.convertImageFormat('bmp', 'png'),
                            ),
                            _buildConversionCard(
                              icon: Icons.image,
                              title: 'GIF to JPG',
                              subtitle: 'Convert GIF images to JPG format',
                              gradient: [
                                Colors.orange.shade500,
                                Colors.orange.shade700
                              ],
                              onTap: () =>
                                  controller.convertImageFormat('gif', 'jpg'),
                            ),
                            _buildConversionCard(
                              icon: Icons.image,
                              title: 'WebP to PNG',
                              subtitle: 'Convert WebP images to PNG format',
                              gradient: [
                                Colors.pink.shade500,
                                Colors.pink.shade700
                              ],
                              onTap: () =>
                                  controller.convertImageFormat('webp', 'png'),
                            ),
                          ],
                          isSmallScreen: isSmallScreen,
                          isMediumScreen: isMediumScreen,
                          screenSize: screenSize,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildStatusSection(controller, isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(isSmallScreen ? 8.0 : 12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.shade100.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_fix_high,
                size: isSmallScreen ? 24.0 : 32.0,
                color: Colors.indigo.shade700,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12.0 : 16.0),
            Text(
              'Image Converter',
              style: TextStyle(
                fontSize: isSmallScreen ? 24.0 : 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 8.0 : 12.0),
        Text(
          'Convert your images easily and quickly',
          style: TextStyle(
            fontSize: isSmallScreen ? 14.0 : 16.0,
            color: Colors.grey.shade600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isSmallScreen) {
    return Row(
      children: [
        Container(
          width: 4,
          height: isSmallScreen ? 20.0 : 24.0,
          decoration: BoxDecoration(
            color: Colors.indigo.shade400,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade400.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        SizedBox(width: isSmallScreen ? 8.0 : 12.0),
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 20.0 : 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversionList(
    List<Widget> cards, {
    required bool isSmallScreen,
    required bool isMediumScreen,
    required Size screenSize,
  }) {
    if (screenSize.width >= 1200) {
      // Desktop layout - Grid view with 4 columns
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.8,
        children: cards,
      );
    } else if (screenSize.width >= 600) {
      // Tablet layout - Grid view with 2 columns
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
        children: cards,
      );
    } else {
      // Mobile layout - Vertical list with full-width cards
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => cards[index],
      );
    }
  }

  Widget _buildConversionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallCard = constraints.maxWidth < 300;
        return Hero(
          tag: title,
          child: Card(
            elevation: 3,
            shadowColor: gradient[0].withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isSmallCard ? 12.0 : 16.0),
            ),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              borderRadius: BorderRadius.circular(isSmallCard ? 12.0 : 16.0),
              child: Container(
                padding: EdgeInsets.all(isSmallCard ? 12.0 : 16.0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(isSmallCard ? 12.0 : 16.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                    stops: const [0.0, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallCard ? 6.0 : 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(isSmallCard ? 6.0 : 8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: isSmallCard ? 20.0 : 24.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: isSmallCard ? 8.0 : 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: isSmallCard ? 14.0 : 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isSmallCard ? 2.0 : 3.0),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: isSmallCard ? 11.0 : 12.0,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.9),
                      size: isSmallCard ? 12.0 : 14.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusSection(
      FileConverterController controller, bool isSmallScreen) {
    return Obx(() {
      if (!controller.isConverting.value && controller.statusMessage.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.only(top: isSmallScreen ? 16.0 : 24.0),
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12.0 : 16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.selectedFileName.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius:
                          BorderRadius.circular(isSmallScreen ? 6.0 : 8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade50.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.file_present,
                      size: isSmallScreen ? 16.0 : 20.0,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8.0 : 12.0),
                  Expanded(
                    child: Text(
                      controller.selectedFileName.value,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12.0 : 14.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12.0 : 16.0),
            ],
            if (controller.isConverting.value) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(isSmallScreen ? 6.0 : 8.0),
                child: LinearProgressIndicator(
                  value: controller.conversionProgress.value,
                  backgroundColor: Colors.indigo.shade100,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.indigo.shade700),
                  minHeight: isSmallScreen ? 6.0 : 8.0,
                ),
              ),
              SizedBox(height: isSmallScreen ? 8.0 : 12.0),
            ],
            Text(
              controller.statusMessage.value,
              style: TextStyle(
                fontSize: isSmallScreen ? 12.0 : 14.0,
                color: controller.statusMessage.value.startsWith('Error')
                    ? Colors.red.shade700
                    : Colors.green.shade700,
                letterSpacing: 0.1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }
}
