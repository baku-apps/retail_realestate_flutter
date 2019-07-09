import 'package:flutter/material.dart';

import 'models/property.dart';

class PropertyGeneralInfo extends StatelessWidget {
  const PropertyGeneralInfo({
    Key key,
    @required Property property,
  }) : _property = property, super(key: key);

  final Property _property;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          _property.address,
          style: Theme.of(context).textTheme.headline,
        ),
        const SizedBox(height: 8.0),
        Text(
          _property.city.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .body2
              .copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Icon(Icons.home),
            Text("Winkelruimte | 89 m2",
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontSize: 14)),
          ],
        )
      ],
    );
  }
}
