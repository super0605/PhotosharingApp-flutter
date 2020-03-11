import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_images_task/models/image_model.dart';
import 'package:share/share.dart';

class ImageCard extends StatefulWidget {
  final ImageModel model;
  final bool isGrayscale;

  const ImageCard({Key key, this.model, this.isGrayscale}) : super(key: key);

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Radius radius = Radius.circular(12);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
        child: Container(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius:
                    BorderRadius.only(topLeft: radius, topRight: radius),
                child: CachedNetworkImage(
                  imageUrl: widget.isGrayscale
                      ? widget.model.grayscaleDownloadUrl
                      : widget.model.downloadUrl,
                  height: 300,
                  width: double.maxFinite,
                  placeholder: (_, __) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) =>
                      Icon(Icons.error_outline, color: Colors.red, size: 100),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('by ${widget.model.author}',
                        style: Theme.of(context).textTheme.subtitle),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () => Share.share(
                          'http://deeplink.littleapps.com/${widget.model.id}/${widget.isGrayscale ? 1 : 0}'),
                      color: Colors.blue,
                      child: Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
