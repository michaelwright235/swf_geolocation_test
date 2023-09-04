package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
    import flash.events.GeolocationEvent;
    import flash.events.MouseEvent;
    import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.events.PermissionEvent;
    import flash.sensors.Geolocation;
    import flash.text.TextField;
    import flash.text.TextFormat;
	import flash.display.DisplayObject;
    import flash.display.Stage;

	public class Test extends MovieClip {
		private var geo:Geolocation; 
        private var log:TextField;
		private var interval:Number;

		public function Test() {
			setUpTextField();
			logNtrace("init");
			interval = 7000;

            logNtrace("Geolocation.isSupported == " + Geolocation.isSupported.toString());
			logNtrace("Geolocation.permissionStatus == " + Geolocation.permissionStatus);
            if (Geolocation.isSupported)
            {
                geo = new Geolocation();
				logNtrace("geo.muted == " + geo.muted.toString());
				logNtrace("geo.setRequestedUpdateInterval(" + interval + ")");
				geo.setRequestedUpdateInterval(interval);
				geo.requestPermission();
                geo.addEventListener(StatusEvent.STATUS, geoStatusHandler);
				geo.addEventListener(PermissionEvent.PERMISSION_STATUS,geoPermissionHandler);
				geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
				geo.locationAlwaysUsePermission = true;
				logNtrace("locationAlwaysUsePermission(true)");
				logNtrace("geo.locationAlwaysUsePermission() == " + geo.locationAlwaysUsePermission.toString());
            }
		}

		        public function geoUpdateHandler(event:GeolocationEvent):void
        {
		    logNtrace("GeolocationEvent.UPDATE: " + event.toString());
        }

		public function geoPermissionHandler(event:PermissionEvent):void
        {
			logNtrace("Geolocation.permissionStatus == " + Geolocation.permissionStatus);
		    logNtrace(event.formatToString("PermissionEvent","type","bubbles","cancelable","status"));
        }

        public function geoStatusHandler(event:StatusEvent):void
        {
			logNtrace("StatusEvent : " + event.toString());
			logNtrace("geoStatusHandler: geo.muted == " + geo.muted.toString());
            if (geo.muted)
                geo.removeEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
            else
                geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
        }

        private function setUpTextField():void
        {
            log = new TextField();
            var format:TextFormat = new TextFormat("_sans", 16);
            log.defaultTextFormat = format;
            log.border = true;
            log.wordWrap = true;
            log.multiline = true;
            log.x = 10;
            log.y = 10;
            log.height = this.stage.stageHeight - 20;
            log.width = this.stage.stageWidth - 20;
			log.addEventListener(MouseEvent.CLICK, clearLog); 
            this.stage.addChild(log);
        }
        private function clearLog(event:MouseEvent):void
        {
            log.text = "";
        }

		private function logNtrace(str: String) {
			trace(str);
			log.appendText(str + "\n");
		}
	}

}
