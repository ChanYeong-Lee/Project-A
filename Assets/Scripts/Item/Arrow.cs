using System;
using UnityEngine;

public class Arrow : Item
{
    private ArrowData arrowData;

    public ArrowData ArrowData => arrowData;
    
    private void Start()
    {
        Init();
    }

    private void Init()
    {
        arrowData = data as ArrowData;
        
        if (arrowData == null)
        {
            arrowData = Managers.Resource.Load<ArrowData>("ScriptableObject/Item/Arrow/Arrow");
            data = arrowData;
        }
    }
    
    // TODO : 보스 몬스터 및 몬스터 구현 후 효과 메소드 구현 예정
    // 화살 효과 발동 메소드
    public virtual void Attack()
    {
        
    }
}