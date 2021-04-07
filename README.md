# wazo-rtpe-config

wazo-rtpe-config provides rtpengine configuration for the C4 infrastructure.

## Installing rtpengine

Please refer to the official repository of [Sipwise RTPengine](https://github.com/sipwise/rtpengine)

## Installing wazo-rtpe-config

The server is already provided as a part of [Wazo](http://documentation.wazo.community).
Please refer to [the documentation](http://documentation.wazo.community/en/stable/installation/installsystem.html) for
further details on installing one.

## Wazo RTPe configuration file

Please edit the `rtpengine.sample.conf` and rename it to `rtpengine.conf` in your `/etc/rtpengine/` directory.

The data needed for RTPe to run in a Wazo environment are:
* `interface` - the IP address of the network interface on which RTPe is available (example: 10.0.0.14)
* `listen-ng` - the port the rtpengine is listening to (example: 22222)
* `redis` - if multiple instances of RTPengine are used for HA define the redis database for sharing infromation between nodes (example: 10.0.0.15:6379/0)

## Integration in Wazo C4

Please refer to [Wazo's C4 Router repository on Gihub](https://github.com/wazo-platform/wazo-c4-router) for an example of how to integrate RTP Engine into a kamailio instance.

We use the [rtpengine module](https://www.kamailio.org/docs/modules/5.2.x/modules/rtpengine.html) so:

```
loadmodule "rtpengine.so"
...
modparam("rtpengine", "rtpengine_sock", RTPENGINE_LIST)
```

Then inside the routing logic we use functions [rtpengine_offer](https://www.kamailio.org/docs/modules/5.2.x/modules/rtpengine.html#rtpengine.f.rtpengine_offer) and [rtpengine_manage](https://www.kamailio.org/docs/modules/5.2.x/modules/rtpengine.html#rtpengine.f.rtpengine_manage).
