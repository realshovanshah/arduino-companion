import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dustbin/bloc/dustbin_bloc.dart';
import 'package:smart_dustbin/models/image_model.dart';
import 'package:smart_dustbin/services/auth_service.dart';
import 'package:smart_dustbin/services/dustbin_service.dart';
import 'package:smart_dustbin/ui/upload/upload_screen.dart';
import 'package:smart_dustbin/utilities/utils.dart';

class DustbinScreen extends StatefulWidget {
  DustbinScreen({Key key}) : super(key: key);

  @override
  _DustbinScreenState createState() => _DustbinScreenState();
}

class _DustbinScreenState extends State<DustbinScreen> {
  String imageUrl;
  final _imageService = ImageService();
  List<int> _selectedItems = List<int>();
  List<ImageModel> _selectedImageList = List<ImageModel>();
  var _isOptionsVisible = true;

  @override
  void initState() {
    BlocProvider.of<ImageBloc>(context).add(ImageLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final _bloc = BlocProvider.of<ImageBloc>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            // stream: widget.firebaseAuth.userChanges(),
            builder: (context, snapshot) {
          // if (snapshot.connectionState != ConnectionState.active)
          //   return LinearProgressIndicator();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'DUSTBINS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: 'sans-serif-light',
                            color: Colors.black),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Long press to select dustbins.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.5,
                      minHeight: screenHeight * 0.5),
                  child: CustomScrollView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                          if (state is ImageLoadFailedState) {
                            return SliverToBoxAdapter(
                              child: Center(
                                  child: Text("An unexpected error occurred")),
                            );
                          }
                          if (state is ImageLoadSuccessState) {
                            return StreamBuilder(
                                stream: state.images,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          return ImageListItem(
                                            imageModel: snapshot.data[index],
                                            selectedItems: _selectedItems,
                                            selectedImageList:
                                                _selectedImageList,
                                            index: int.parse(
                                                snapshot.data[index].id),
                                          );
                                        },
                                        childCount: snapshot.data.length,
                                      ),
                                    );
                                  } else {
                                    return SliverToBoxAdapter(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text("No data found"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            LinearProgressIndicator()
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                });
                          } else {
                            return SliverToBoxAdapter(
                                child: LinearProgressIndicator());
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  FlatButton(
                      onPressed: () {
                        if (_selectedItems.isEmpty) {
                          return Utils.showSnackbar(
                              context, "No image is selected.");
                        } else {
                          setState(() {
                            _selectedItems.clear();
                            _selectedImageList.clear();
                          });
                        }
                      },
                      textColor: Theme.of(context).accentColor,
                      child: Text('Cancel')),
                  FlatButton(
                      onPressed: () {
                        if (_selectedItems.isEmpty) {
                          return Utils.showSnackbar(
                              context, "No image is selected.");
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            settings: RouteSettings(
                                arguments: List<String>.from(
                                    _selectedImageList.map((e) => e.id))),
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<ImageBloc>(context),
                              child: UploadScreen(
                                text: "Choose dustbins to update with.",
                              ),
                            ),
                          ));
                        }
                      },
                      textColor: Theme.of(context).accentColor,
                      child: Text('Update')),
                  RaisedButton(
                      onPressed: () {
                        print("Count is: ${_selectedImageList.length}");
                        _bloc.add(ImageDeletedEvent(_selectedImageList));
                        // _selectedItems.clear();
                        // _selectedImageList.clear();
                      },
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text('Delete')),
                  SizedBox(width: 20)
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, top: 12.0, bottom: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Upload a Dustbin!',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ImageBloc>(context),
                        child: UploadScreen(
                          text: "Add a Dustbin!",
                        ),
                      ),
                    ));
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ImageListItem extends StatefulWidget {
  const ImageListItem({
    Key key,
    @required List<int> selectedItems,
    @required this.index,
    this.imageModel,
    this.selectedImageList,
  })  : _selectedItems = selectedItems,
        super(key: key);

  final List<int> _selectedItems;
  final List<ImageModel> selectedImageList;
  final int index;
  final ImageModel imageModel;

  @override
  _ImageListItemState createState() => _ImageListItemState();
}

class _ImageListItemState extends State<ImageListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget._selectedItems.contains(widget.index)) {
          setState(() {
            widget._selectedItems.removeWhere((val) => val == widget.index);
            widget.selectedImageList.remove(widget.imageModel);
          });
        }
      },
      onLongPress: () {
        if (!widget._selectedItems.contains(widget.index)) {
          setState(() {
            widget._selectedItems.add(widget.index);
            widget.selectedImageList.add(widget.imageModel);
          });
        }
      },
      title: Container(
        alignment: Alignment.center,
        height: 150,
        color: (widget._selectedItems.contains(widget.index))
            ? Theme.of(context).accentColor.withOpacity(0.7)
            : Theme.of(context).accentColor.withOpacity(0.2),
        child: ListTile(
          trailing: Icon(Icons.opacity, color: Colors.black),
          leading: (widget.imageModel.imageUrl == null)
              ? FlutterLogo(
                  size: 100,
                )
              : Image.network(widget.imageModel.imageUrl,
                  height: 100, width: 100, fit: BoxFit.cover),
          subtitle: Row(
            children: [
              Text(
                "Fill status: ",
                style: TextStyle(fontSize: 10),
              ),
              Text(widget.imageModel.fillStatus),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 1, top: 6),
            child: Row(
              children: [
                Text(
                  "Dustbin id: ",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  "${widget.index}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
