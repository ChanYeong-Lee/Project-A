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
    
    // TODO : ���� ���� �� ���� ���� �� ȿ�� �޼ҵ� ���� ����
    // ȭ�� ȿ�� �ߵ� �޼ҵ�
    public virtual void Attack()
    {
        
    }
}