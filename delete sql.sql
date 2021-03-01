Step 4: TimeKeeper 휴가 삭제 

Foreach(string approval_no in vacation_list.Except(create_list))
{
	sql = $@“DECLARE @user_no INT 
	
	select @user_no = U.user_no 
	from [dbo].[tb_vacation] V with(nolock)
	Inner Join [dbo].[tb_approval] A on A.approval_no = V.approval_no and A.status = ‘accept’ 
	Inner Join [dbo].[tb_user] U on U.user_no = V.user_no AND U.retireYN = ’N’
	where V.approval_no = ‘{approval_no}’
	update A
	SET A.status = ‘refuse’
	from [dbo].[tb_approval] A with(ROWLOCK)
	where A.approval_no = {approval_no}
        —vacation history : 휴가를 삭제(취소) 했다는 history를 조회하기 위함 
	
                                 INSERT INTO [dbo].[tb_vacation_history] WITH(ROWLOCK)
                                 (user_no, vacation_name, approval_no, vacation_days)
                                 VALUES
                                 (@user_no, '[취소]', {approval_no}, -(SELECT vacation_days FROM tb_vacation WHERE approval_no = {approval_no}))

                                 DELETE FROM [dbo].[tb_vacation] WITH(ROWLOCK)
                                 WHERE user_no = @user_no AND approval_no = {approval_no}

                                 SELECT {approval_no} AS approval_no";



}