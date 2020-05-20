/// Represents the Network-Values from the Glances-API.
class Network {
    String interfaceName;

    double timeSinceUpdate;

    int cumulativeReceive;

    int receive;

    int cumulativeTx;

    int tx;

    int cumulativeCx;

    int cx;

    bool isUp;

    int speed;

    String key;

    /// Constructor for Network-Objects.
    Network(String interfaceName, double timeSinceUpdate, int cumulativeReceive, int receive, int cumulativeTx, int tx, int cumulativeCx, int cx, bool isUp, int speed, String key) {
        this.interfaceName = interfaceName;
        this.timeSinceUpdate = timeSinceUpdate;
        this.cumulativeReceive = cumulativeReceive;
        this.receive = receive;
        this.cumulativeTx = cumulativeTx;
        this.tx = tx;
        this.cumulativeCx = cumulativeCx;
        this.cx = cx;
        this.isUp = isUp;
        this.speed = speed;
        this.key = key;
    }

    /// For deserialization of JSON and conversion to Network-Object.
    factory Network.fromJson(dynamic json) {
        return Network(
            json['interface_name'] as String,
            double.parse(json['time_since_update'].toString()),
            json['cumulative_rx'] as int,
            json['rx'] as int,
            json['cumulative_tx'] as int,
            json['tx'] as int,
            json['cumulative_cx'] as int,
            json['cx'] as int,
            json['is_up'] as bool,
            json['speed'] as int,
            json['key'] as String
        );
    }
}