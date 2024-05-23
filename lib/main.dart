import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

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
      home: const Scaffold(body: MyCarousel()),
    );
  }
}
class CarouselItems{

}

class MyCarousel extends StatefulWidget {
  
 const  MyCarousel({super.key});

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {

  late Future<List<Media>> filmes;

      @override
  void initState() {
    super.initState();
    filmes = carregarFilmes();
  }

  //Verificar se tem internet , para poder carregar o ficheiro json

  Future<List<Media>> carregarFilmes() async {
    final String response = await rootBundle.loadString('lib/data.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Media.fromJson(json)).toList();
  }

//Datasource
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
       physics: const BouncingScrollPhysics(),
             child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
        FutureBuilder<List<Media>>(
          future : filmes,
          builder:  (context, snapshot) {
  
             if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar filmes'));
          } else {
            return CustomSlider(
                itemBuilder: (context, itemIndex, _){
                  final filmes=snapshot.data;
                  return SliderCard(
                    media: filmes![itemIndex],
                    itemIndex: itemIndex,
                  );
                },
              );

          }
          }
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

    factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      title: json['title'],
      backdropUrl: json['backdrop_path'],
      releaseDate: json['release_date'],
    );
  }
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
    //   return CachedNetworkImage(
    //   imageUrl: imageUrl,
    //   height: height,
    //   width: width,
    //   fit: BoxFit.cover,
    //   placeholder: (_, __) => Shimmer.fromColors(
    //     baseColor: Colors.grey[850]!,
    //     highlightColor: Colors.grey[800]!,
    //     child: Container(
    //       height: height,
    //       color: Colors.white,
    //     ),
    //   ),
    //   errorWidget: (_, __, ___) => const Icon(
    //     Icons.error,
    //     color:Colors.red
    //   ),
    // );
    return Image.asset(
        "assets/img/"+imageUrl, 
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
