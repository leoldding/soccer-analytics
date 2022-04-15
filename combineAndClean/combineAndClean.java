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

public class combineAndClean{
    public static void main(String[] args) throws Exception{
        Job job = new Job();
        job.setJarByClass(combineAndClean.class);
        job.setJobName("Combine and Clean Data");
        job.setNumReduceTasks(1);

        String paths = "";
        for(int i = 0; i < args.length-1; i++)
        {
            paths = paths + args[i] + ",";
        }
	
	FileInputFormat.setInputDirRecursive(job, true);
        FileInputFormat.addInputPath(job, new Path( args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[args.length-1]));

        job.setMapperClass(combineAndCleanMapper.class);
        job.setReducerClass(combineAndCleanReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
