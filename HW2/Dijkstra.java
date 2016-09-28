import java.io.*;
import java.util.*;

public class Dijkstra 
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
        in = new BufferedReader(new FileReader("/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/Edges2.txt"));
        line = in.readLine();
        do
        {
        	String[] each = line.split(",");
        	arr_main[hm.get(each[0])][hm.get(each[1])] = Integer.parseInt(each[2]);
        	arr_main[hm.get(each[1])][hm.get(each[0])] = Integer.parseInt(each[2]);
        	line=in.readLine();
        }while(line!=null);
        Dijkstra t = new Dijkstra();
        long startTime = System.nanoTime();
        t.dijkstra(arr_main, 0, 24);
        long endTime = System.nanoTime();
        System.out.println("Dijkstra's algorithm took " + (endTime - startTime) + " nano seconds");

	}
	public void dijkstra(int arr[][],int src, int dest)
	{
		int[] visit = new int[count];
		int[] dist=new int[count];
		int i=0, number_of_nodes=1, minimum=0, min_index=0;
		for (i=0;i<count;i++)
		{
			dist[i]=arr[src][i];
			visit[i]=0;
		}
		visit[src] = 1;
		while(number_of_nodes!=count)
		{
			minimum = Integer.MAX_VALUE;
			for(i=0;i<count;i++)
			{
				if ((dist[i]<minimum) && (visit[i]!=1))
				{
					minimum = dist[i];
					min_index = i;
				}
			}
			visit[min_index] = 1;
			number_of_nodes++;
			for (i=0; i<count; i++)
			{
				if ((minimum + arr[min_index][i] < dist[i]) && (visit[i]!=1))
				{
					dist[i] = minimum + arr[min_index][i];
				}
			}
			if (min_index == dest)
				break;
		}
		int number_of_1s=0;
		for (i=0;i<count;i++)
			if (visit[i]==1)
				number_of_1s = number_of_1s + 1;
		System.out.println("Number of nodes is "+number_of_1s);
		System.out.println("Dist to dest is "+dist[dest]);
	}
	
}
