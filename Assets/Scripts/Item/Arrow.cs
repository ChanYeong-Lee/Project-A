using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using static UnityEngine.ParticleSystem;

public class Arrow : Item
{
    [SerializeField] protected float moveSpeed = 30.0f;
    [SerializeField] protected TrailRenderer trail;
    [SerializeField] protected Transform arrowHead;
    public ArrowData ArrowData => data as ArrowData;
    protected Coroutine shotCoroutine;
    protected CapsuleCollider col;

    [SerializeField] protected GameObject[] explosionParticle;
    [SerializeField] protected GameObject[] trailParticle;

    protected Action onShotBegin;
    protected Action onShot;
    protected Action onShotEnd;


    // TODO : 보스 몬스터 및 몬스터 구현 후 효과 메소드 구현 예정
    // 화살 효과 발동 메소드
    public virtual void Attack()
    {

    }

    protected virtual void Awake()
    {
        col = GetComponent<CapsuleCollider>();

        foreach (GameObject gameObject in explosionParticle)
        {
            onShotEnd += () =>
            {
                GameObject particle = Managers.Resource.Instantiate(gameObject);
                particle.transform.position = gameObject.transform.position;
                particle.transform.rotation = gameObject.transform.rotation;
                particle.SetActive(true);
            };
        }

        foreach (GameObject gameObject in trailParticle)
        {
            onShotBegin += () =>
            {
                GameObject particle = Managers.Resource.Instantiate(gameObject, transform);
                particle.transform.position = gameObject.transform.position;
                particle.transform.rotation = gameObject.transform.rotation;

                particle.SetActive(true);
            };
        }
    }

    protected virtual void OnEnable()
    {
        trail.Clear();
        trail.enabled = false;
    }

    protected virtual void OnDisable()
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
            if (Vector3.Distance(target.transform.position, arrowHead.position) < 1.0f)
            {
                onShotEnd?.Invoke();    
                break;
            }

            if (Physics.Raycast(arrowHead.position, transform.forward, 1.0f))
            {
                onShotEnd?.Invoke();
                break;
            }

            onShot?.Invoke();

            transform.LookAt(target.transform);
            transform.position += transform.forward * moveSpeed * Time.deltaTime;

            yield return null;
        }

        Managers.Pool.Push(gameObject);
    }
 
    private void OnCollisionEnter(Collision collision)
    {
        onShotEnd?.Invoke();
        Managers.Pool.Push(gameObject);
    }
}
