import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
 

    return MaterialApp(
      title: 'My Carousel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Scaffold(body: MyCarousel()),
    );
  }
}
class CarouselItems{

}

class MyCarousel extends StatelessWidget {
  
   MyCarousel({super.key});

  

//Datasource
 final List<Media> filmes = [
    Media(
      title: 'Filme 1',
      backdropUrl: 'assets/img/tpiqEVTLRz2Mq7eLq5DT8jSrp71.jpg',
      releaseDate: '12',
    ),
    Media(
      title: 'Filme 2',
      backdropUrl: 'assets/img/kYgQzzjNis5jJalYtIHgrom0gOx.jpg',
      releaseDate: '13',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
       physics: const BouncingScrollPhysics(),
             child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        CustomSlider(
            itemBuilder: (context, itemIndex, _) {
              return SliderCard(
                media: filmes[itemIndex],
                itemIndex: itemIndex,
              );
            },
          ),
          ]
        
        )
    );
  }
}

class Media{
  String? backdropUrl;
  String? title;
  String? releaseDate;
  Media(
    {
      this.backdropUrl,
      this.title,
      this.releaseDate
    }
  );
}

class SliderCard extends StatelessWidget {
  const SliderCard({
    super.key,
    required this.media,
    required this.itemIndex,
  });

  final Media media;
  final int itemIndex;
  

  

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        
      },
      child: SafeArea(
        child: Stack(
          children: [
            SliderCardImage(imageUrl: media.backdropUrl!),
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                bottom: 10,
              ),
              child: SizedBox(
                height: size.height * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title!,
                      maxLines: 2,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      media.releaseDate!,
                      style: textTheme.bodyLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          2,
                          (indexDot) {
                            return Container(
                              margin:
                                  const EdgeInsets.only(right: 10),
                              width: indexDot == itemIndex
                                  ? 30
                                  : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: indexDot == itemIndex
                                    ? const Color(0xffef233c)
                                    : const Color(0x26ffffff),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderCardImage extends StatelessWidget {
  const SliderCardImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.3, 0.5, 1],
        ).createShader(
          Rect.fromLTRB(0, 0, rect.width, rect.height),
        );
      },
      child: ImageWithShimmer(
        height: size.height * 0.6,
        width: double.infinity,
        imageUrl: imageUrl,

      ),
    );
  }
}

class ImageWithShimmer extends StatelessWidget {
  const ImageWithShimmer({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        imageUrl, 
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
  }
}


class CustomSlider extends StatelessWidget {
  final Widget Function(BuildContext context, int itemIndex, int) itemBuilder;
  const CustomSlider({
    required this.itemBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CarouselSlider.builder(
      itemCount: 2,
      options: CarouselOptions(
        viewportFraction: 1,
        height: size.height * 0.55,
        autoPlay: true,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
