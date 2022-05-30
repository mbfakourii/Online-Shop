import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'common_utils.dart';

//ignore: must_be_immutable
class ImageShow extends StatefulWidget {
  ImageShow(this.url, {Key? key, this.fit, this.width, this.height})
      : super(key: key);
  String url;
  final BoxFit? fit;

  final double? width;
  final double? height;

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  @override
  Widget build(BuildContext context) {
    return () {
      if (isLink(widget.url)) {
        return CachedNetworkImage(
          fit: widget.fit,
          imageUrl: widget.url,
          width: widget.width,
          height: widget.height,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      } else if (widget.url == "") {
        return Container();
      } else {
        return Image.file(
          File(widget.url),
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        );
      }
    }();
  }
}
