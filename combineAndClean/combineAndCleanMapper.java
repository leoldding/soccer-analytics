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
        // split values in each row
        String[] values = value.toString().split(",");

        // creat StringBuilder to compile good rows
        java.lang.StringBuilder record = new java.lang.StringBuilder();

        // check if there are a minimum of 22 attributes
        if (values.length >= 22)
        {
            // viableRecord keeps track if a record can still be used based on format criteria
            boolean viableRecord = true;

            // breakout point 1 if record is not viable
            loop1:
            // iterate through first 5 values
            for(int i = 0; i < 4; i++)
            {
                // make sure all are String values
                if(isInt(values[i]))
                {
                    // mark bad record
                    viableRecord = false;
                    break loop1;
                }

                // reformat date input
                if(i == 1 && values[i].contains("-"))
                {
                    String date = values[i];
                    values[i] = date.substring(8,10) + "/" + date.substring(5,7) + "/" + date.substring(2,4);
                }
                else if(i == 1 && values[i].length() == 10)
                {
                    String date = values[i];
                    values[i] = date.substring(0,6) + date.substring(8,10);
                }

                // add values to record builder
                record.append(values[i]).append(",");
            }
            if(viableRecord)
            {
                // breakout point 2 if record is not viable
                loop2:
                for(int i = 4; i < 10; i++)
                {
                    if(i % 3 == 0)
                    {
                        // encode results
                        if(isInt(values[i]))
                        {
                            // mark bad record
                            viableRecord = false;
                            break loop2;
                        }
                        else if(values[i].equals("H"))
                        {
                            values[i] = "1";
                        }
                        else if(values[i].equals("A"))
                        {
                            values[i] = "-1";
                        }
                        else
                        {
                            values[i] = "0";
                        }
                    }
                    else if(!isInt(values[i]))
                    {
                        // mark bad record
                        viableRecord = false;
                        break loop2;
                    }
                    // add values to record builder
                    record.append(values[i]).append(",");
                }
            }
            if(viableRecord)
            {
                // check for extra 'referee' column in English data and clean accordingly
                if(isInt(values[10]))
                {
                    // breakout point 3 if record is not viable
                    loop3:
                    for(int i = 10; i < 22; i++)
                    {
                        if(!isInt(values[i]))
                        {
                            // mark bad record
                            viableRecord = false;
                            break loop3;
                        }
                        // add values to record builder
                        record.append(values[i]).append(",");
                    }
		        }
                else
                {
                    // breakout point 3 if record is not viable
                    loop3:
                    for(int i = 11; i < 23; i++)
                    {
                        if(!isInt(values[i]))
                        {
                            // mark bad values
                            viableRecord = false;
                            break loop3;
                        }
                        // add values to record builder
                        record.append(values[i]).append(",");
                    }
                }
            }
            if(viableRecord)
            {
                // write the record out if it is viable
                context.write(new Text("record"), new Text(record.toString()));
            }
        }
    }

    // method to check whether a given value is an integer
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

