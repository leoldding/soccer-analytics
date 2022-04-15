import java.io.IOException;
import java.util.StringTokenizer;
import java.util.*;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class combineAndCleanMapper extends Mapper<Object, Text, Text, Text> {
    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        String[] values = value.toString().split(",");
        java.lang.StringBuilder record = new java.lang.StringBuilder();
        if (values.length >= 22) {
            boolean viableRecord = true;
            loop1:
            for(int i = 0; i < 4; i++) {
                if(isInt(values[i])) {
                    viableRecord = false;
                    break loop1;
                }
                if(i == 1 && values[i].contains("-")){
                    String date = values[i];
                    values[i] = date.substring(8,10) + "/" + date.substring(5,7) + "/" + date.substring(2,4);
                }
                else if(i == 1 && values[i].length() == 10){
                    String date = values[i];
                    values[i] = date.substring(0,6) + date.substring(8,10);
                }
                record.append(values[i]).append(",");
            }
            if(viableRecord)
            {
                loop2:
                for(int i = 4; i < 10; i++)
                {
                    if(i % 3 == 0) {
                        if(isInt(values[i])) {
                            viableRecord = false;
                            break loop2;
                        }
                    }
                    else
                    {
                        if(!isInt(values[i]))
                        {
                            viableRecord = false;
                            break loop2;
                        }
                    }
                    record.append(values[i]).append(",");
                }
            }
            if(viableRecord)
            {
		if(isInt(values[10]))
		{
                    loop3:
                    for(int i = 10; i < 22; i++)
                    {
                        if(!isInt(values[i]))
                        {
                            viableRecord = false;
                            break loop3;
                        }
                        record.append(values[i]).append(",");
                    }
		}
		else
		{
		    loop3:
		    for(int i = 11; i < 23; i++)
		    {
			if(!isInt(values[i]))
			{
			    viableRecord = false;
			    break loop3;
			}
		    }
		}
            }
            if(viableRecord)
            {
                context.write(new Text("record"), new Text(record.toString().substring(0,record.length()-1)));
            }
        }
    }

    public boolean isInt(String check) {
        try
        {
            int temp =  Integer.parseInt(check);
            return true;
        }
        catch(NumberFormatException e)
        {
            return false;
        }
    }
}

