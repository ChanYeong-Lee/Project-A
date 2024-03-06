using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class Arrow : Item
{
    [SerializeField] private float moveSpeed = 30.0f;
    [SerializeField] private TrailRenderer trail;
    [SerializeField] private Transform arrowHead;
    public ArrowData ArrowData => data as ArrowData;
    private Coroutine shotCoroutine;

    [SerializeField] protected UnityEvent onShotBegin;
    [SerializeField] protected UnityEvent onShot;
    [SerializeField] protected UnityEvent onShotEnd;

    // TODO : ���� ���� �� ���� ���� �� ȿ�� �޼ҵ� ���� ����
    // ȭ�� ȿ�� �ߵ� �޼ҵ�
    public virtual void Attack()
    {

    }

    protected virtual void OnEnable()
    {
        trail.Clear();
        trail.enabled = false;
    }

    private void OnDisable()
    {
        if (shotCoroutine != null)
        {
            StopCoroutine(shotCoroutine);
        }
    }

    public void Shot(AttackPoint target)
    {
        transform.LookAt(target.transform);
        shotCoroutine = StartCoroutine(ShotCoroutine(target));
    }

    protected IEnumerator ShotCoroutine(AttackPoint target)
    {
        onShotBegin?.Invoke();

        trail.enabled = true;
        float distance = Vector3.Distance(arrowHead.position, target.transform.position);
        
        while (true)
        {
            if (Vector3.Distance(arrowHead.position, target.transform.position) < 1.0f)
            {
                onShotEnd?.Invoke();
                yield return null;
                break;
            }

            onShot?.Invoke();

            transform.LookAt(target.transform);
            transform.position += transform.forward * moveSpeed * Time.deltaTime;

            yield return null;
        }

        Managers.Pool.Push(gameObject);
    }

}
