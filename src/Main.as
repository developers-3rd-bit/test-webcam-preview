package
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   [SWF(width="1280", height="800")]
   public class Main extends Sprite
   {
      private var _bg:McBg;
      private var _webcamPreviewGroup:WebcamPreviewGroup;
      
      public function Main()
      {
         _bg = new McBg();
         //this.addChild(_bg);
         
         _webcamPreviewGroup = new WebcamPreviewGroup(this, 400, 500);
         _webcamPreviewGroup.x = 440;
         _webcamPreviewGroup.y = 150;
         _webcamPreviewGroup.addEventListener(WebcamPreviewGroup.CLOSE_BTN_CLICK, onCloseBtnClick, false, 0, true);
         
         this.addChild(_webcamPreviewGroup);
      }
      
      private function onCloseBtnClick(event:Event):void
      {
         this.removeChild(_webcamPreviewGroup);
      }
   }
}