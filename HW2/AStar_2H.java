import java.io.*;
import java.util.*;

public class AStar_2H
{
	static int count=0;
	public static void main(String args[])throws IOException
	{
		String line;
		HashMap<String, Integer> hm=new HashMap<String, Integer> ();
		BufferedReader in;
        in = new BufferedReader(new FileReader("/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/Nodes.txt"));
        line = in.readLine();
        while(line != null)
        {
               if (line !=null)
               {
            	   String[] each = line.split("-");
            	   hm.put(each[1], Integer.parseInt(each[0]));
            	   count++;
               }
               line = in.readLine();
      
        }
        in.close();
        int [][] arr_main = new int[count][count];
        for (int i=0;i<count;i++)
        {
        	for (int j=0;j<count;j++)
        	{
        		if (i==j)
        			arr_main[i][j]=0;
        		else
        			arr_main[i][j]=10000;
        	}
        }
        in = new BufferedReader(new FileReader("/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/Edges.txt"));
        line = in.readLine();
        do
        {
        	String[] each = line.split(",");
        	arr_main[hm.get(each[0])][hm.get(each[1])] = Integer.parseInt(each[2]);
        	arr_main[hm.get(each[1])][hm.get(each[0])] = Integer.parseInt(each[2]);
        	line=in.readLine();
        }while(line!=null);
        AStar_2H t = new AStar_2H();
        long startTime = System.nanoTime();
        t.astar(arr_main, 0, 24);
        long endTime = System.nanoTime();
        System.out.println("A-star algorithm took " + (endTime - startTime) + " nano seconds");
	}
	public void astar(int arr[][],int src, int dest)
	{
		int[] visit = new int[count];
		int[] dist=new int[count];
		int[] est=new int[count];
		int i=0, number_of_nodes=1, minimum=0, min_index=0, minimum2=0;
		double total_estimate=0.0, heuristics=0.0;
		for (i=0;i<count;i++)
		{
			dist[i]=arr[src][i];
			est[i] = arr[src][i];
			visit[i]=0;
		}
		visit[src] = 1;
		while(number_of_nodes!=count)
		{
			minimum2 = Integer.MAX_VALUE;
			for(i=0;i<count;i++)
			{
				if ((est[i]<minimum2) && (visit[i]!=1))
				{
					minimum2 = est[i];
					minimum = dist[i];
					min_index = i;
				}
			}
			visit[min_index] = 1;
			number_of_nodes++;
			for (i=0; i<count; i++)
			{	
				Random rand=new Random();
				heuristics = rand.nextInt(450) + 1;
				total_estimate = minimum + arr[min_index][i]+(int)heuristics;
				if ((total_estimate < est[i]) && (visit[i]!=1))
				{
					est[i]=(int) total_estimate;
					dist[i] = minimum + arr[min_index][i];
				}
			}
			//System.out.println(min_index);
			if (min_index == dest)
				break;
		}
		int number_of_1s=0;
		for (i=0;i<count;i++)
			if (visit[i]==1)
				number_of_1s = number_of_1s + 1;
		System.out.println("Number of nodes visited is "+number_of_1s);
		System.out.println("Dist to dest is "+dist[dest]);
	}
}
