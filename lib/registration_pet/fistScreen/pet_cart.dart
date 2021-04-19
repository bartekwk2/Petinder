import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PetCart extends StatelessWidget {
  final dynamic petName;
  const PetCart({Key key, this.petName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(4, 4),
                blurRadius: 10,
                color: Colors.grey.withOpacity(.2),
              ),
              BoxShadow(
                offset: Offset(-3, 0),
                blurRadius: 15,
                color: Colors.grey.withOpacity(.1),
              )
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    child: Text(
                      petName.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 100,
                    height: 100,
                    child: CachedNetworkImage(imageUrl: petName.photo))
              ],
            ),
          )),
    );
  }
}
