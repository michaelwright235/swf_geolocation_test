package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
    import flash.events.GeolocationEvent;
    import flash.events.MouseEvent;
    import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.events.PermissionEvent;
	import flash.permissions.PermissionStatus;
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
			logNtrace("Geolocation.permissionStatus == " + Geolocation.permissionStatus);
            if (Geolocation.isSupported)
            {
                logNtrace("Geolocation is supported");
                geo = new Geolocation();
				logNtrace("geo.muted == " + geo.muted.toString());
                if (!geo.muted) {
                    geo.setRequestedUpdateInterval(interval);
                    geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
                }
                geo.addEventListener(StatusEvent.STATUS, geoStatusHandler);
            } else {
                logNtrace("Geolocation is not supported");
            }
		}

		public function geoUpdateHandler(event:GeolocationEvent):void
        {
		    logNtrace("GeolocationEvent.UPDATE: " + event.toString());
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
			log.scrollV=log.maxScrollV;
		}
	}

}
