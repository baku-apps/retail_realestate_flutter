import 'package:flutter/material.dart';

class ExapandableWidget extends StatefulWidget {
  ExapandableWidget(
      {Key key,
      this.child,
      this.expandText,
      this.shrinkText,
      this.maxHeight = 0})
      : super(key: key);

  final String expandText;
  final String shrinkText;
  final double maxHeight;
  final Widget child;

  _ExapandableWidgetState createState() => _ExapandableWidgetState();
}

class _ExapandableWidgetState extends State<ExapandableWidget>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;
  bool isExpanded = false;

  GlobalKey _containerKey = GlobalKey();
  Size _containerSize = Size(0, 0);

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
        
    //get size of widget: https://coflutter.com/flutter/get-size-and-position-of-a-widget-in-flutter/
    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
  }

  _onBuildCompleted(_) {
    _getContainerSize();
  }

  _getContainerSize() {
    final RenderBox containerRenderBox =
        _containerKey.currentContext.findRenderObject();

    final containerSize = containerRenderBox.size;

    setState(() {
      _containerSize = containerSize;
    });
  }

  ///Setting up the animation
  Animation<double> prepareAnimations() {
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );

    double animationBegin;
    if (_containerSize.height > 0)
      animationBegin = widget.maxHeight / _containerSize.height;
    else
      animationBegin = 0;

    animation = Tween(begin: animationBegin, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

      return animation;
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //prepareAnimations();

    return Column(children: <Widget>[
      SizeTransition(
          axisAlignment: -1.0,
          sizeFactor: prepareAnimations(),
          child: Container(key: _containerKey, child: widget.child)),
      isExpanded
          ? buildFlatButton(context, false)
          : buildFlatButton(context, true)
    ]);
  }

  FlatButton buildFlatButton(BuildContext context, bool expand) {
    return FlatButton(
        child: Text(
          isExpanded ? widget.shrinkText : widget.expandText,
          style: Theme.of(this.context).textTheme.button,
        ),
        onPressed: () => setState(() {
              isExpanded = expand;
              if (isExpanded) {
                expandController.forward();
              } else {
                expandController.reverse();
              }
            }));
  }
}
