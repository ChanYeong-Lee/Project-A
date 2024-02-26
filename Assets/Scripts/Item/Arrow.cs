using System;
using UnityEngine;

public class Arrow : Item
{
    private ArrowData arrowData;
    
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
    private void Activate()
    {
        switch (arrowData.Attribute)
        {
            case Define.AttributeType.None:
                break;
            case Define.AttributeType.Light:
                break;
            case Define.AttributeType.Bomb:
                break;
            case Define.AttributeType.Glue:
                break;
            case Define.AttributeType.Poison:
                break;
            case Define.AttributeType.Fire:
                break;
            case Define.AttributeType.Electric:
                break;
            case Define.AttributeType.Etc:
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }
    
    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.CompareTag("Monster"))
        {
            Activate();
        }
    }
}