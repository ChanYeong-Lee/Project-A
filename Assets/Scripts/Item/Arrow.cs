using System;
using System.Collections;
using UnityEngine;

public class Arrow : Item
{
    [SerializeField] private float moveSpeed = 30.0f;
    [SerializeField] private TrailRenderer trail;
    [SerializeField] private Transform arrowHead;
    public ArrowData ArrowData => data as ArrowData;

    //private void Start()
    //{
    //    Init();
    //}

    //private void Init()
    //{
    //    arrowData = data as ArrowData;

    //    if (arrowData == null)
    //    {
    //        arrowData = Managers.Resource.Load<ArrowData>("ScriptableObject/Item/Arrow/Arrow");
    //        data = arrowData;
    //    }
    //}

    // TODO : ���� ���� �� ���� ���� �� ȿ�� �޼ҵ� ���� ����
    // ȭ�� ȿ�� �ߵ� �޼ҵ�
    public virtual void Attack()
    {

    }

    protected virtual void OnEnable()
    {
        trail.enabled = false;
    }

    public void Shot(AttackPoint target)
    {
        StartCoroutine(ShotCoroutine(target));
    }

    protected IEnumerator ShotCoroutine(AttackPoint target)
    {
        trail.enabled = true;
        float distance = Vector3.Distance(transform.position, target.transform.position);
        
        while (true)
        {
            float remainDistance = Vector3.Distance(transform.position, target.transform.position);
            if (Vector3.Distance(transform.position, target.transform.position) < 1.0f)
            {
                break;
            }
            
            Vector3 dir = (target.transform.position + Mathf.Sin(remainDistance / distance * Mathf.PI) * 5.0f * Vector3.up) - transform.position;

            transform.forward = dir;
            transform.position = transform.position + transform.forward * moveSpeed * Time.deltaTime;

            yield return null;
        }

        Managers.Pool.Push(gameObject);
    }

}
