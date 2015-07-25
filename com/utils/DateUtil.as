package com.utils
{
	public class DateUtil
	{
		public function DateUtil()
		{
		}
		
		//转换时间格式
		public static function formatDateString(date:Date):String
		{
			var y0:Number = date.fullYearUTC%100;
        	var y1:int = y0/10;
			var y2:int = y0%10;
			var year:String = y1.toString()+ y2.toString();
        	var text:String = /*year + "年" + */(date.month + 1) + "月" + date.date + "日" + 
        	(date.hours < 10?("0" + date.hours):date.hours) + "时" /*+ ":" + 
			(date.minutes < 10?("0" + date.minutes):date.minutes) + ":" + 
			(date.seconds < 10?("0" + date.seconds):date.seconds);*/
        	return text;
		}
		/**
		 *格式化時間，返回字符串 
		 * @param date
		 * @param format
		 * @return 
		 * 
		 */		
		public static function toDateCustomFormat(date:Date,format:String = "YYYY-MM-DD JJ:NN:SS"):String
		{
			/*if(date==null)
			{
				return "date is null"
			}
			var dateFormat :DateFormatter = new DateFormatter();
			dateFormat.formatString = format;
			return dateFormat.format(date);*/
			return "";
		}
		/**
		 *比较两个日期的大小 
		 * @param sourceDate 
		 * @param distDate
		 * @return true(sourceDate >distDate)  false(sourceDate <= sourceDate)
		 * 
		 */		
		public static function compareTwoDate(sourceDate:Date,distDate:Date):Boolean
		{
			if(sourceDate == null || distDate == null)
			{
				throw new Error("Date is Null!");
			}
			var sourceDateTimes :Number = sourceDate.getTime();
			var distDateTimes :Number = distDate.getTime();
			if(sourceDateTimes > distDateTimes)
			{
				return true;
			}else
			{
				return false;
			}
		}
		/**
		 * 
		 * @param startDate
		 * @param endDate
		 * @return 
		 */		
		public static function validateDates(startDate:Date,endDate:Date):Boolean
		{
			if(startDate == null && endDate == null)
			{
				return true;
			}
			if((startDate != null && endDate == null) || (endDate != null && startDate == null))
			{
				//SamvoAlert.showText("Please select startDate or endDate!","Remind");
				return true;
			}
			
			if(compareTwoDate(startDate,endDate))
			{
				//SamvoAlert.showText("End date must greater than start date!","Error");
				return false;
			}
			
			return true;
		}
		/**
		 * 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function parseDateString(str:String):Date
		{
			if(str == null)
			{
				return new Date();
			}
			
			//return DateFormatter.parseDateString(str);
			return new Date();
		}
		/**
		 *比较两个日期差 是否大于等于years
		 * @param birthday
		 * @param today 
		 * @param years
		 * @return 
		 * 
		 */		
		public static function validateTwoYear(birthday:Date,today:Date = null,years:int = 18):Boolean
		{
			if(birthday == null)
			{
				return false;
			}
			
			if(today == null)
			{
				today = new Date();
			}
			
			var distYears :int = today.getFullYear() - birthday.getFullYear();
			
			if(distYears >= years)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 *格式化時間，返回当前日期的最大时间，比如2011-02-11 ，返回2011-02-11 23:59:59 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function toDateMaxFormat(date:Date):Date
		{
			if(date==null)
			{
				return date;
			}
			var newDate :Date = new Date(date.getFullYear(),date.getMonth(),date.getDate(),23,59,59);
			return newDate;
		}
		/**
		 *格式化時間，返回当前日期的最小时间，比如2011-02-11 ，返回2011-02-11 00:00:00 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function toDateMinFormat(date:Date):Date
		{
			if(date==null)
			{
				return date;
			}
			var newDate :Date = new Date(date.getFullYear(),date.getMonth(),date.getDate(),0,0,0);
			return newDate;
		}
		/**
		 *转换当前时间为GMT-4 Time Zone 时间 
		 * @param data
		 * @return 
		 * 
		 */		
		public static function transDateToGMTNegativeFour(date:Date):Date
		{
			if(date == null)
			{
				return null;
			}
			
			return new Date(date.setMilliseconds((date.getTimezoneOffset()- 240) * 60000));
		}
		/**
		 * 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function transDateToNegativeFourHoursLater(date:Date):Date
		{
			if(date == null)
			{
				return null;
			}
			//trace("before");
			//trace(date.toLocaleString());
			var resDate :Date = new Date(date.setMilliseconds((240 - date.getTimezoneOffset()) * 60000));
			//trace("after");
			//trace(resDate.toLocaleString());
			return resDate;
		}
		/**
		 * 比较两个时间 
		 * @param fDate
		 * @param tDate
		 * @param seconds
		 * @return 如果fDate 大于等于 tDate + seconds 返回true，否则返回false.
		 */		
		public static function validateBetweenTwoDate(fDate:Date,tDate:Date,seconds :int):Boolean
		{
			if(fDate == null || tDate == null)
			{
				return false;
			}
			var gap :Number = fDate.getTime() - tDate.getTime();
			if(gap >= (seconds * 1000))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}