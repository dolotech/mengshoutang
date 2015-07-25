package treefortress.spriter
{
	import treefortress.spriter.core.Animation;
	import treefortress.spriter.core.Child;
	import treefortress.spriter.core.ChildReference;
	import treefortress.spriter.core.Mainline;
	import treefortress.spriter.core.MainlineKey;
	import treefortress.spriter.core.Piece;
	import treefortress.spriter.core.Timeline;
	import treefortress.spriter.core.TimelineKey;
	
	public class AnimationSet
	{
		private var animationList:Vector.<Animation>;
		protected var piecesByFolderId:Object;
		protected var animationsByName:Object;
		
		private var pieces:Vector.<Piece> = new Vector.<Piece>;

		public function AnimationSet(data:XML){
			piecesByFolderId = { };
			animationsByName = { };
			var folder:XMLList = data.folder;
			for each(var folderXml:XML in folder){
				var folderId:String = folderXml.@id;
				for each(var file:XML in folderXml.file){
					var piece:Piece = new Piece();
					piece.id = file.@id;
					piece.folder = folderId;
					piece.name = file.@name;
					piece.name = piece.name.split(".")[0];
					//Strip preceding classes (Spriter is injecting them for no reason. Bug?)
					if(piece.name.substr(0, 1) == "/"){
						piece.name = piece.name.substr(1);
					}
					piece.width = file.@width;
					piece.height = file.@height;
					piecesByFolderId[piece.folderId] = piece;	
					pieces.push(piece);
				}
			}
			
			animationList = new Vector.<Animation>;
			var anim:Animation;
			
			var mainlineKeys:Vector.<MainlineKey>;
			var mainlineKey:MainlineKey;
			
			var timelineKeys:Vector.<TimelineKey>;
			var timelineKey:TimelineKey;
			
			var animation:XMLList = data.entity.animation;
			for each(var animData:XML in animation) {
				anim = new Animation();
				anim.id = animData.@id;
				anim.name = animData.@name;
				anim.length = animData.@length;
				anim.looping = (animData.@looping == undefined || animData.@looping == true);
				
				//Add timelines
				var timeline:XMLList = animData.timeline;
				for each(var timelineData:XML in timeline) {
					timelineKeys = new <TimelineKey>[];
					anim.timelineList.push(new Timeline(timelineData.@id, timelineKeys));
					
					//Add TimelineKeys
					var timelineDataKey:XMLList = timelineData.key;
					for each(var keyData:XML in timelineDataKey) {
						timelineKey = new TimelineKey();
						timelineKey.id = keyData.@id;
						timelineKey.time = keyData.@time;
						timelineKey.spin = keyData.@spin;
						
						//Check whether it's a bone (Assume: if not an object, it must be a bone)
						var isBone:Boolean = false;
						var childData:XML = keyData..object[0];
						if(!childData){ 
							childData = keyData..bone[0];
							isBone = true;
						}
						if(!childData || childData.@file == undefined){ continue; }
						
						var child:Child = new Child();
						child.x = childData.@x ;
						child.y = childData.@y ;
						child.angle = childData.@angle;
						child.alpha = (childData.@a == undefined)? 1 : childData.@a;
						
						//Convert to flash degrees (spriters uses 0-360, flash used 0-180 and -180 to -1)
						var rotation:Number = child.angle;
						if(rotation >= 180){ rotation = 360 - rotation;
						} else { rotation = -rotation; }
						child.angle = rotation;
						
						//Ignore bones
						if(!isBone){
							child.piece = piecesByFolderId[childData.@folder + "_" + childData.@file];
							child.pivotX = (childData.@pivot_x == undefined)? 0 : childData.@pivot_x;
							child.pivotY = (childData.@pivot_y == undefined)? 1 : childData.@pivot_y;
							child.pixelPivotX = child.piece.width * child.pivotX;
							child.pixelPivotY = child.piece.height * (1 - child.pivotY);
						}
						child.scaleX = (childData.@scale_x == undefined)? 1 : childData.@scale_x;
						child.scaleY = (childData.@scale_y == undefined)? 1 : childData.@scale_y;
						
						timelineKey.child = child;
						timelineKeys.push(timelineKey);
					}
				}
				
				//Add Mainline
				mainlineKeys = new <MainlineKey>[];
				var mainlinekey:XMLList = animData.mainline.key;
				for each(var mainKey:XML in mainlinekey) {
					
					//Add Main Keyframes
					mainlineKey = new MainlineKey();
					mainlineKey.id = mainKey.@id;
					mainlineKey.time = mainKey.@time;
					mainlineKeys.push(mainlineKey);
					
					//Add Object to KeyFrame
					mainlineKey.refs = new <ChildReference>[];
					var object_ref:XMLList = mainKey.object_ref;
					for each(var refData:XML in object_ref) {
						var ref:ChildReference = new ChildReference();
						ref.id = refData.@id;
						ref.timeline = refData.@timeline; //timelineId
						ref.key = refData.@key; //timelineKey
						ref.zIndex = refData.@z_index;
						mainlineKey.refs.push(ref);
					}
				}
				
				//A bit of a hack to support Animation Looping...
				if(anim.looping && anim.length > mainlineKey.time){
					//Automatically insert a new MainLineKey at the very end of the animation, 
					var endKey:MainlineKey = new MainlineKey();
					endKey.time = anim.length;
					endKey.id = mainlineKey.id + 1;
					//Use the references from the first frame to create the looping effect
					endKey.refs = mainlineKeys[0].refs;
					mainlineKeys.push(endKey);
				}
				
				anim.mainline = new Mainline(mainlineKeys);
				animationsByName[anim.name] = anim;
			
				animationList.push(anim);
			}
		}
		
		public function getAnimations():Object {
			return animationsByName;
		}
	}
}


