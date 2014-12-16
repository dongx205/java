import java.util.*;

public class BinaryCode {
	
	public String[] decode(String c){
		String[] result =  new String[2];
		int length = c.length();
		int[] zero = new int[length];
		int[] one = new int[length];
		zero[0] = 0;
		one[0] = 1;
		int[] array = new int[length];	
		for(int i = 0; i < length; ++i){
			array[i] = Integer.parseInt(String.valueOf(c.charAt(i)));
		}
		if(length == 1){
			zero[0] = array[0];
			one[0] = array[0];
		}
		if(length >= 2){
			zero[1] = array[0] - zero[0];
			one[1] = array[0] - one[0];
		}
		if(length > 2){
			for(int i = 2; i < length; ++i){
				zero[i] = array[i - 1] - zero[i - 1] - zero[i - 2];
				one[i] = array[i - 1] - one[i - 1]- one[i - 2];
			}
		}
		for(int i = 0; i < length; ++i){
			if(zero[i] > 1 || zero[i] < 0)
			result[0] = "NONE";
			if(one[i] > 1 || one[i] < 0)
			result[1] = "NONE";
		}
		if(length > 2){
			if(array[length - 1] != zero[length - 1] + zero[length - 2]){
				result[0] = "NONE";
			}
			if(array[length - 1] != one[length - 1] + one[length - 2]){
				result[1] = "NONE";
			}
		}
		if(result[0] != "NONE")
			result[0] = Arrays.toString(zero);
		if(result[1] != "NONE")
			result[1] = Arrays.toString(one);
		return result;
	}
	
}
