import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({this.data, this.onTap});

  final ScanResult data;
  final VoidCallback onTap;
  final debug = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: _buildRSSI(context),
      trailing: _buildConnectButton(),
      children: <Widget>[
        _buildDetails(
            context, 'Nome local completo:', data.advertisementData.localName.length > 0 ? '${data
            .advertisementData.localName}' : '...' ),
        _buildDetails(context, 'Taxa de transmissão:',
            '${data.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildDetails(context, 'mac', '${data.device.id}'),
        debug ? _buildDetails(context, 'serviços (debug):', '${data.advertisementData.serviceUuids
            .toString()}' ?? 'N/A') : null,
      ],
    );
  }

  RaisedButton _buildConnectButton() {
    bool connectable = data.advertisementData.connectable;
    return RaisedButton.icon(
      onPressed: connectable ? onTap : null,
      icon: Icon(connectable ? Icons.bluetooth : Icons.bluetooth_disabled),
      label: Text(connectable ? 'Conectar' : 'Indisponivel'),
    );
  }

  RichText _buildRSSI(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(Icons.rss_feed),
            ),
          ),
          TextSpan(text: data.rssi.toString()),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (data.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${data.device.name}',
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${data.device.id.toString()}',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text('${data.device.id.toString()}');
    }
  }

  Widget _buildDetails(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.caption.apply(color: Colors.white54),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
