package chap8;

public class exe1 {
	public static void main(String[] args){
		System.out.println(Itefibo(10));
	}
	public int Recfibo(int n){
		if(n == 1 || n == 2)
			return 1;
		return Recfibo(n -1 ) + Recfibo(n - 2);
	}
	public static int Itefibo(int n){
		int result = 0;
		int tmp1 = 1;
		int tmp2 = 1;
		if(n == 1 || n == 2)
			return 1;
		for(int i = 3; i <= n; ++i){
			result = tmp1 + tmp2;
			tmp1 = tmp2;
			tmp2 = result;
		}
		return result;
	}
}
